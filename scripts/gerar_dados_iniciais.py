import csv
import sys
from collections import Counter, OrderedDict
from decimal import Decimal, InvalidOperation

NUMERICAS = ["inscritos", "participantes", "nota_bruta_formacao_geral",
             "nota_bruta_componente_especifico", "conceito_enade_continuo"]


def esc(valor):
    if valor is None or valor == "":
        return "NULL"
    return "'" + valor.replace("\\", "\\\\").replace("'", "''") + "'"


def num(valor):
    return "NULL" if valor == "" else valor


HASH_DEMO = "$2y$12$e6CxI2JMsQfpiNk3aJSqWOeOxV4RvAzj/TQFxNPLO8zVpNb8UcL8C"

ACOES_DEMO = [
    ("Revisar conteúdos de raciocínio quantitativo",
     "Revisar a ementa e os exercícios das disciplinas de estatística e matemática financeira, "
     "alinhando-os ao perfil de questões do ENADE.",
     "Em andamento", "NDE do curso", "2026-11-30", "plano.pdf", "demo_plano_acao.pdf"),
    ("Aplicar simulado interdisciplinar",
     "Aplicação de simulado com questões de formação geral e de componente específico "
     "para os concluintes, com devolutiva por área.",
     "Concluída", "Coordenação", "2026-10-15", "registro_oficina.png", "demo_registro_oficina.png"),
    ("Oficina de questões discursivas",
     "Oficina prática para treinar a resolução e a correção de questões discursivas "
     "com os estudantes do último ano.",
     "Planejada", "Docentes", "2027-03-20", None, None),
]


def secao_demo():
    out = []
    out.append("-- Usuário de demonstração (login: demo / senha: demo123).")
    out.append("-- A senha é guardada com password_hash(..., PASSWORD_DEFAULT), nunca em texto puro.")
    out.append("-- CONFERIR: o PDF do projeto pede o usuário \"no formato utilizado no exemplo da aula\";")
    out.append("-- se o exemplo da aula usar outro formato (texto puro, md5...), ajustar HASH_DEMO e o login.")
    out.append("INSERT INTO usuario (nome, login, senha) VALUES")
    out.append(f"({esc('Usuário demonstrador')}, {esc('demo')}, {esc(HASH_DEMO)});")
    out.append("")
    out.append("-- Ações de exemplo da oferta O01. Anexos reais em app/uploads/ (gerados por")
    out.append("-- scripts/gerar_anexos_demo.py); anexo_arquivo guarda só o nome armazenado.")
    out.append("INSERT INTO acao (oferta_id, titulo, descricao, situacao, responsavel, prazo,")
    out.append("    anexo_nome_original, anexo_arquivo) VALUES")
    out.append(",\n".join(
        f"((SELECT id FROM oferta WHERE codigo='O01'), {esc(t)}, {esc(d)}, {esc(s)}, {esc(r)}, "
        f"{esc(p)}, {esc(no)}, {esc(na)})"
        for t, d, s, r, p, no, na in ACOES_DEMO) + ";")
    out.append("")
    return out


def main():
    if len(sys.argv) < 2:
        sys.exit("Uso: python -I scripts/gerar_dados_iniciais.py CSV [saida.sql]")
    csv_path = sys.argv[1]
    saida = sys.argv[2] if len(sys.argv) > 2 else "banco/dados_iniciais.sql"

    with open(csv_path, encoding="utf-8-sig", newline="") as f:
        linhas = list(csv.DictReader(f, delimiter=";"))

    ofertas = OrderedDict()
    anomalias = []
    for l in linhas:
        ofertas.setdefault(l["oferta_id"], (l["recorte_id"], l["curso"],
                                            l["grau_academico"], l["modalidade"]))
        ref = f"{l['oferta_id']}/{l['ano']}"
        val = {}
        for c in NUMERICAS:
            if l[c] == "":
                anomalias.append(f"{ref}: {c} vazio")
                continue
            try:
                val[c] = Decimal(l[c])
            except InvalidOperation:
                anomalias.append(f"{ref}: {c} não numérico ({l[c]!r})")
        if "inscritos" in val and "participantes" in val and val["participantes"] > val["inscritos"]:
            anomalias.append(f"{ref}: participantes ({val['participantes']}) > inscritos ({val['inscritos']})")
        for c in ("nota_bruta_formacao_geral", "nota_bruta_componente_especifico"):
            if c in val and not (0 <= val[c] <= 100):
                anomalias.append(f"{ref}: {c} fora de 0-100 ({val[c]})")
        if "conceito_enade_continuo" in val and not (0 <= val["conceito_enade_continuo"] <= 5):
            anomalias.append(f"{ref}: conceito_enade_continuo fora de 0-5 ({val['conceito_enade_continuo']})")
        if l["conceito_enade_faixa"] not in ("1", "2", "3", "4", "5", "SC"):
            anomalias.append(f"{ref}: conceito_enade_faixa inválido ({l['conceito_enade_faixa']!r})")
        if l["origem_dado"] not in ("OFICIAL_INEP", "SIMULADO_DIDATICO"):
            anomalias.append(f"{ref}: origem_dado inválido ({l['origem_dado']!r})")

    por_origem = Counter(l["origem_dado"] for l in linhas)
    out = []
    out.append("USE painel_enade;")
    out.append("")
    out.append("-- Dados iniciais do Painel ENADE (T04 e T05) - gerado por scripts/gerar_dados_iniciais.py")
    out.append("-- Conteúdo: ofertas e resultados do R01; usuário de demonstração (demo) e 3 ações de")
    out.append("-- exemplo da oferta O01 (2 com anexo em app/uploads/).")
    out.append("-- Fonte: arquivo do professor datasets_enade_2015_2025/dados_por_recorte/R01_enade_2015_2025.csv (recorte R01).")
    out.append(f"-- Total: {len(linhas)} resultados em {len(ofertas)} ofertas "
               f"({por_origem['OFICIAL_INEP']} OFICIAL_INEP e {por_origem['SIMULADO_DIDATICO']} SIMULADO_DIDATICO).")
    out.append("-- origem_dado foi mantido exatamente como no CSV: dados simulados NAO sao oficiais.")
    out.append("-- ATENCAO: ponto_forte e ponto_atencao sao SUGESTOES do CSV (ponto_forte_sugerido /")
    out.append("-- ponto_atencao_sugerido) e devem ser revisados pelo grupo.")
    out.append("-- Execute depois de banco/estrutura.sql (que recria as tabelas vazias).")
    out.append("")
    out.append("INSERT INTO oferta (codigo, recorte_id, curso, grau_academico, modalidade) VALUES")
    out.append(",\n".join(
        f"({esc(cod)}, {esc(r)}, {esc(cu)}, {esc(g)}, {esc(m)})"
        for cod, (r, cu, g, m) in ofertas.items()) + ";")
    out.append("")
    out.append("INSERT INTO resultado (oferta_id, ano, inscritos, participantes, nota_formacao_geral,")
    out.append("    nota_componente_especifico, conceito_continuo, conceito_faixa, ponto_forte, ponto_atencao, origem_dado) VALUES")
    tuplas = []
    for l in linhas:
        tuplas.append(
            f"((SELECT id FROM oferta WHERE codigo={esc(l['oferta_id'])}), {num(l['ano'])}, "
            f"{num(l['inscritos'])}, {num(l['participantes'])}, "
            f"{num(l['nota_bruta_formacao_geral'])}, {num(l['nota_bruta_componente_especifico'])}, "
            f"{num(l['conceito_enade_continuo'])}, {esc(l['conceito_enade_faixa'])}, "
            f"{esc(l['ponto_forte_sugerido'])}, {esc(l['ponto_atencao_sugerido'])}, {esc(l['origem_dado'])})")
    out.append(",\n".join(tuplas) + ";")
    out.append("")
    out.extend(secao_demo())

    with open(saida, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out))

    print(f"Gerado: {saida}")
    print(f"Ofertas: {len(ofertas)} | Resultados: {len(linhas)} | Origem: {dict(por_origem)}")
    print(f"Anomalias: {len(anomalias)}")
    for a in anomalias:
        print("  -", a)


if __name__ == "__main__":
    main()
