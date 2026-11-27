import react from '@vitejs/plugin-react'
import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), 'VITE_')
  const alvo = process.env.VITE_PROXY_TARGET || env.VITE_PROXY_TARGET || 'http://localhost:8080/api'

  return {
    plugins: [react()],
    base: './',
    build: {
      outDir: '../painel',
      emptyOutDir: true,
    },
    server: {
      proxy: {
        // /api/me.php -> <alvo>/me.php
        '/api': {
          target: alvo,
          changeOrigin: true,
          rewrite: (caminho) => caminho.replace(/^\/api/, ''),
        },
      },
    },
  }
})
