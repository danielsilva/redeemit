import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vite.dev/config/
export default defineConfig(({ mode }) => ({
  plugins: [react()],
  server: {
    port: 3001
  },
  build: {
    // Only output to root public assets folder in production
    ...(mode === 'production' && {
      outDir: '../public/assets',
      emptyOutDir: false, // Don't empty the entire assets folder, just replace our files
      manifest: true, // Generate manifest.json for asset fingerprinting
      rollupOptions: {
        input: {
          main: path.resolve(__dirname, 'src/main.tsx')
        },
        output: {
          entryFileNames: '[name]-[hash].js',
          chunkFileNames: '[name]-[hash].js',
          assetFileNames: '[name]-[hash].[ext]'
        }
      }
    })
  }
}))
