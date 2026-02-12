RSpec.describe "`ckancli upload` command", type: :cli do
  it "executes `ckancli help upload` command successfully" do
    output = `ckancli help upload`
    expected_output = <<~OUT
Usage:
  ckancli upload

Options:
  -h, [--help], [--no-help]                        # Display usage information
  -d, --dir=DIR                                    # Path to CSV files. Full path to directory or URL.
  -r, --resourceconfig=RESOURCECONFIG              # CKAN resource metadata file (JSON). Absolute or relative path.
  -c, --configuration=CONFIGURATION                # Global configuration file (JSON). Absolute or relative path.
  -v, [--validationschema=VALIDATIONSCHEMA]        # Validation schema (JSON). Absolute or relative path.
  -p, [--datasetconfig=DATASETCONFIG]              # CKAN dataset metadata file (JSON). Absolute or relative path.
  -m, [--updatemodified], [--no-updatemodified]    # Update modified date of resource.
  -i, [--ignoreextension], [--no-ignoreextension]  # Ignore file extensions (process all files not only CSV).
  -w, [--overwrite], [--no-overwrite]              # Overwrite resource if existing is found by identifier.

Processes CSV files and uploads to CKAN API.
OUT

    expect(output).to eq(expected_output)
  end
end
