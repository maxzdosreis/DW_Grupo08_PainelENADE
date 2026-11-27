import { logout } from '../api.js'

export default function PainelPlaceholder({ usuario, aoSair }) {
  async function sair() {
    await logout()
    aoSair()
  }

  return (
    <div className="pagina-painel">
      <header className="barra-topo">
        <span className="fw-semibold">Painel ENADE</span>
        <span className="d-flex align-items-center gap-3">
          <span>{usuario?.nome}</span>
          <button type="button" className="btn btn-sm btn-outline-light" onClick={sair}>
            Sair
          </button>
        </span>
      </header>
      <main className="container py-5">
        <h1 className="h3 titulo-painel">Painel ENADE</h1>
        <p className="text-secondary">Conteúdo do painel será adicionado nas próximas tarefas</p>
      </main>
    </div>
  )
}
