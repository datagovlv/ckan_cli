RSpec.describe "`ckancli upload` command", type: :cli do
  it "executes `ckancli help upload` command successfully" do
    output = `ckancli help upload`
    expected_output = <<-OUT
Usage:
  ckancli upload

Options:
  -h, [--help], [--no-help]  # Display usage information

Upload CKAN resources
    OUT

    expect(output).to eq(expected_output)
  end
end
