using Documenter


include("pages.jl")

makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = pages
)

deploydocs(
    repo = "github.com/Hirlam/HarmonieSystemDocumentation.git",
    # devurl = "dev",
    versions = ["dev" => "dev", "stable" => "cy43h2.2"]
)
