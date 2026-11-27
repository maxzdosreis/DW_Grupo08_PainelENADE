import { useEffect, useState } from 'react'
import { usuarioAtual } from './api.js'
import Login from './components/Login.jsx'
import PainelPlaceholder from './components/PainelPlaceholder.jsx'

export default function App() {
  const [estado, setEstado] = useState('carregando')
  const [usuario, setUsuario] = useState(null)

  useEffect(() => {
    let ativo = true
    usuarioAtual().then((r) => {
      if (!ativo) return
      if (r.ok) {
        setUsuario(r.dados.usuario)
        setEstado('logado')
      } else {
        setEstado('deslogado')
      }
    })
    return () => {
      ativo = false
    }
  }, [])

  function aoEntrar(u) {
    setUsuario(u)
    setEstado('logado')
  }

  function aoSair() {
    setUsuario(null)
    setEstado('deslogado')
  }

  if (estado === 'carregando') {
    return (
      <div className="tela-centro">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Carregando...</span>
        </div>
      </div>
    )
  }

  if (estado === 'logado') {
    return <PainelPlaceholder usuario={usuario} aoSair={aoSair} />
  }

  return <Login aoEntrar={aoEntrar} />
}
