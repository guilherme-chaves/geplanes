import { defineConfig } from "drizzle-kit";

export default defineConfig({
  out: "./database/out",
  schema: "./database/schemas",
  dialect: "postgresql",
  dbCredentials: {
    url: Deno.env.get("DATABASE_URL")!, // postgresql://[user[:password]@][host][:port]/[dbname]
  },
});
