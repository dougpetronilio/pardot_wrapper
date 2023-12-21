# frozen_string_literal: true

require_relative "lib/pardot/version"

Gem::Specification.new do |spec|
  spec.name = "pardot_wrapper"
  spec.version = Pardot::VERSION
  spec.authors = ["DougPetronilio"]
  spec.email = ["dougpetronilio@gmail.com"]

  spec.summary = "Pardot Wrapper Api v5"
  spec.description = "A gem PardotWrapper é uma biblioteca Ruby projetada para simplificar a interação com a API do Pardot, especificamente com a versão 5. Ela oferece uma interface clara e objetiva para realizar operações comuns, como visualizar informações de conta, criar prospects e gerenciar associações de listas. Esta gem abstrai as complexidades das chamadas de API e do tratamento de dados, permitindo que os desenvolvedores se concentrem na lógica de negócios principal de suas aplicações."

  spec.homepage = "https://github.com/dougpetronilio/pardot_wrapper"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dougpetronilio/pardot_wrapper"
  spec.metadata["changelog_uri"] = "https://github.com/dougpetronilio/pardot_wrapper"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "httparty"

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webmock', '~> 3.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
