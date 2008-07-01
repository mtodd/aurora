# Load DB config
Halcyon.db = Halcyon::Config::File.load(Halcyon.root/'config'/'database.yml')[Halcyon.environment]
