import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :scroller, ScrollerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WIzjE0q/Tjh0GuoaVd/cBfo3OEc0UsxqFL+msx01Kj+dcTuv0tA1GWaiqK4E7URC",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
