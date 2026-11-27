import { useState } from 'react'
import { login as fazerLogin } from '../api.js'

export default function Login({ aoEntrar }) {
  const [usuario, setUsuario] = useState('')
  const [senha, setSenha] = useState('')
  const [erros, setErros] = useState({})
  const [erroServidor, setErroServidor] = useState('')
  const [enviando, setEnviando] = useState(false)

  async function enviar(evento) {
    evento.preventDefault()
    setErroServidor('')

    const novosErros = {}
    if (usuario.trim() === '') novosErros.login = 'Informe o login.'
    if (senha === '') novosErros.senha = 'Informe a senha.'
    setErros(novosErros)
    if (Object.keys(novosErros).length > 0) return

    setEnviando(true)
    const r = await fazerLogin(usuario.trim(), senha)
    setEnviando(false)
    setSenha('')

    if (r.ok) {
      aoEntrar(r.dados.usuario)
    } else {
      setErroServidor(r.dados.erro || 'Não foi possível entrar. Tente novamente.')
    }
  }

  return (
    <main className="tela-centro">
      <div className="card cartao-login shadow-sm">
        <div className="card-body p-4">
          <h1 className="h3 titulo-painel mb-1">Painel ENADE</h1>
          <p className="text-secondary mb-4">Gestão por indicadores</p>

          {erroServidor && (
            <div className="alert alert-danger" role="alert">
              {erroServidor}
            </div>
          )}

          <form onSubmit={enviar} noValidate>
            <div className="mb-3">
              <label htmlFor="login" className="form-label">Login</label>
              <input
                id="login"
                name="login"
                type="text"
                className={'form-control' + (erros.login ? ' is-invalid' : '')}
                autoComplete="username"
                value={usuario}
                onChange={(e) => setUsuario(e.target.value)}
                disabled={enviando}
              />
              {erros.login && <div className="invalid-feedback">{erros.login}</div>}
            </div>

            <div className="mb-4">
              <label htmlFor="senha" className="form-label">Senha</label>
              <input
                id="senha"
                name="senha"
                type="password"
                className={'form-control' + (erros.senha ? ' is-invalid' : '')}
                autoComplete="current-password"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                disabled={enviando}
              />
              {erros.senha && <div className="invalid-feedback">{erros.senha}</div>}
            </div>

            <button type="submit" className="btn btn-primary w-100" disabled={enviando}>
              {enviando ? 'Entrando...' : 'Entrar'}
            </button>
          </form>
        </div>
      </div>
    </main>
  )
}
