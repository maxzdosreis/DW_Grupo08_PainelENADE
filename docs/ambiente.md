# Ambiente comum da equipe – Painel ENADE

## Versões definidas (mínimas)

| Item | Versão | Observação |
|---|---|---|
| PHP | 8.2 ou superior | extensões `pdo` e `pdo_mysql` habilitadas |
| MySQL / MariaDB | MariaDB 10.4+ ou MySQL 8.0+ | versão instalada na máquina de referência: **a confirmar** |
| XAMPP | versão com PHP 8.2+ | instalação na máquina de referência: **a confirmar** |
| Node.js | 20 LTS ou superior | testado com v20.20.2 |
| npm | 10 ou superior | testado com 10.8.2 |

## Portas
- Apache: **80** (http://localhost/)
- MySQL: **3306**

## Banco de dados
- Nome do banco: `painel_enade`
- Charset: `utf8mb4`
- Collation: `utf8mb4_unicode_ci`
- Usuário de desenvolvimento: `root`, **sem senha** (padrão do XAMPP)

Esses valores ficam em `app/config/config.php`, criado a partir de `app/config/config.example.php` (o `config.php` não é versionado).

## Criar o banco

**phpMyAdmin** (http://localhost/phpmyadmin): aba *Bancos de dados* → nome `painel_enade` → collation `utf8mb4_unicode_ci` → *Criar*.

**Terminal** (pasta `bin` do MySQL do XAMPP, ex.: `C:\xampp\mysql\bin`):

```powershell
.\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS painel_enade CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

## Subir o ambiente
1. Abrir o **XAMPP Control Panel** e clicar em *Start* em **Apache** e **MySQL**.
2. Copiar a pasta do projeto (ou o conteúdo de `app/`) para `htdocs`, por exemplo `C:\xampp\htdocs\DW_Grupo08_PainelENADE\`.
3. Copiar `app/config/config.example.php` para `app/config/config.php`.
4. Criar o banco `painel_enade` (seção acima) e importar `banco/estrutura.sql` e `banco/dados_iniciais.sql`.
5. Acessar http://localhost/DW_Grupo08_PainelENADE/app/.
