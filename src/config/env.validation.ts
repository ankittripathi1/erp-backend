export function validateEnv(config: Record<string, unknown>) {
  const required = ["DATABASE_URL", "JWT_SECRET"];
  for (const key of required) {
    if (!config[key]) {
      throw new Error(`${key} is required`);
    }
  }

  return {
    ...config,
    PORT: config.PORT ? Number(config.PORT) : 8000,
    CORS_ORIGIN: config.CORS_ORIGIN ?? "http://localhost:3000",
    RATE_LIMIT_MAX: config.RATE_LIMIT_MAX ? Number(config.RATE_LIMIT_MAX) : 100,
  };
}
