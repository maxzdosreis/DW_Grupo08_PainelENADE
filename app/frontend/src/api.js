export const API_BASE = import.meta.env.DEV ? '/api' : '../api'

const ERRO_REDE = 'Não foi possível conectar ao servidor.'

export async function pedir(caminho, opcoes = {}) {
  const { metodo = 'GET', corpo } = opcoes
  const config = {
    method: metodo,
    credentials: 'same-origin',
    headers: { Accept: 'application/json' },
  }
  if (corpo !== undefined) {
    config.headers['Content-Type'] = 'application/json'
    config.body = JSON.stringify(corpo)
  }

  try {
    const resposta = await fetch(`${API_BASE}/${caminho}`, config)
    const dados = await resposta.json().catch(() => null)
    return {
      ok: resposta.ok && dados !== null && dados.ok !== false,
      status: resposta.status,
      dados: dados ?? { ok: false, erro: 'Resposta inesperada do servidor.' },
    }
  } catch {
    return { ok: false, status: 0, dados: { ok: false, erro: ERRO_REDE } }
  }
}

export function login(login, senha) {
  return pedir('login.php', { metodo: 'POST', corpo: { login, senha } })
}

export function logout() {
  return pedir('logout.php', { metodo: 'POST' })
}

export function usuarioAtual() {
  return pedir('me.php')
}
