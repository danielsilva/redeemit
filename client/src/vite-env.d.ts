/// <reference types="vite/client" />

declare global {
  interface Window {
    redeemit?: {
      API_BASE_URL: string
    }
  }
}

export {}