import path from "path";
import vue from "@vitejs/plugin-vue";
import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  plugins: [
    vue(),
    VitePWA({
      registerType: "autoUpdate",
      injectRegister: "auto",
      includeAssets: ["favicon.svg", "robots.txt", "apple-touch-icon.png"],
      manifest: {
        name: "Time manager",
        short_name: "TM",
        description:
          "L'application Time Manager est conçue pour optimiser la gestion du temps de travail au cœur de Gotham City",
        theme_color: "#ffffff",
        icons: [
          {
            src: "time-manager-icon-192.png",
            sizes: "192x192",
            type: "image/png",
          },
          {
            src: "time-manager-icon-512.png",
            sizes: "512x512",
            type: "image/png",
          },
        ],
      },
    }),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
