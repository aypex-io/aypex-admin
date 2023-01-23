require_relative "lib/aypex/admin/version"

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = "aypex-admin"
  spec.version = Aypex::Admin.version
  spec.authors = ["Matthew Kennedy"]
  spec.email = "m.kennedy@me.com"
  spec.summary = "Admin for Aypex eCommerce platform"
  spec.description = "An alternative Admin UI for Aypex eCommerce platform."
  spec.homepage = "https://github.com/MatthewKennedy/aypex_admin"
  spec.license = "BSD-3-Clause"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aypex-io/aypex-admin/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "https://github.com/aypex-io/aypex-admin/releases/tag/v#{spec.version}"
  spec.metadata["bug_tracker_uri"] = "https://github.com/aypex-io/aypex-admin/issues"
  spec.metadata["documentation_uri"] = "https://aypex.io/docs"

  spec.required_ruby_version = ">= 3.2"

  spec.files = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  spec.require_path = "lib"

  spec.add_dependency "aypex"
  spec.add_dependency "aypex-api"
  spec.add_dependency "inline_svg"
  spec.add_dependency "pagy"
  spec.add_dependency "responders"
  spec.add_dependency "turbo-rails"

  spec.add_development_dependency "aypex_dev_tools"
end
