all

rule 'MD013', :code_blocks => false, :tables => false

exclude_rule 'MD040' # Fenced code blocks should have a language specified
exclude_rule 'MD041' # First line in file should be a top level header
