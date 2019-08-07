require 'ckancli/commands/upload'

RSpec.describe Ckancli::Commands::Upload do
  it "executes `upload` command successfully" do
    output = StringIO.new
    options = {}
    command = Ckancli::Commands::Upload.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
