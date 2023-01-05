require_relative "lib/aypex/admin/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "aypex_admin"
  s.version = Aypex::Admin.version
  s.authors = ["Matthew Kennedy"]
  s.email = "m.kennedy@me.com"
  s.summary = "Admin for Aypex eCommerce platform"
  s.description = "An alternative Admin UI for Aypex eCommerce platform."
  s.homepage = "https://github.com/MatthewKennedy/aypex_admin"
  s.license = "BSD-3-Clause"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/MatthewKennedy/aypex_admin/issues",
    "changelog_uri" => "https://github.com/MatthewKennedy/aypex_admin/releases/tag/v#{s.version}",
    "documentation_uri" => "https://github.com/MatthewKennedy/aypex_admin/",
    "source_code_uri" => "https://github.com/MatthewKennedy/aypex_admin/tree/v#{s.version}"
  }

  s.required_ruby_version = ">= 2.7"

  s.files = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = "lib"

  s.add_dependency "inline_svg"
  s.add_dependency "pagy"
  s.add_dependency "responders"
  s.add_dependency "aypex"
  s.add_dependency "turbo-rails"
end
