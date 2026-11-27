import { useState } from 'react'
import { logout } from '../api.js'

export default function PainelPlaceholder({ usuario, aoSair }) {
  const [saindo, setSaindo] = useState(false)
  const [erro, setErro] = useState('')

  async function sair() {
    setErro('')
    setSaindo(true)
    const r = await logout()
    setSaindo(false)
    if (r.ok) {
      aoSair()
    } else {
      setErro(r.dados.erro || 'Não foi possível sair. Tente novamente.')
    }
  }

  return (
    <div className="pagina-painel">
      <header className="barra-topo">
        <span className="fw-semibold">Painel ENADE</span>
        <span className="d-flex align-items-center gap-3">
          <span>{usuario?.nome}</span>
          <button
            type="button"
            className="btn btn-sm btn-outline-light"
            onClick={sair}
            disabled={saindo}
          >
            {saindo ? 'Saindo...' : 'Sair'}
          </button>
        </span>
      </header>
      <main className="container py-5">
        {erro && (
          <div className="alert alert-danger" role="alert">
            {erro}
          </div>
        )}
        <h1 className="h3 titulo-painel">Painel ENADE</h1>
        <p className="text-secondary">Conteúdo do painel será adicionado nas próximas tarefas</p>
      </main>
    </div>
  )
}
