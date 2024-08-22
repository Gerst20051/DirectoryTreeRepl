describe 'DirectoryTreeRepl' do
  def run(commands)
    raw_output = nil
    IO.popen('./directories.rb', 'r+') do |pipe|
      commands.each do |command|
        pipe.puts command
      end
      pipe.close_write
      raw_output = pipe.gets(nil)
    end
    raw_output.split("\n")
  end

  it 'invalid command' do
    result = run(['DESTROY fruits'])
    expect(result).to eq([
      "Invalid Command 'DESTROY' Skipped",
    ])
  end

  it 'invalid command is skipped' do
    result = run(['DESTROY fruits', 'CREATE fruits', 'LIST'])
    expect(result).to eq([
      "Invalid Command 'DESTROY' Skipped",
      'CREATE fruits',
      'LIST',
      'fruits',
    ])
  end

  it 'delete command when no directories exist' do
    result = run(['DELETE fruits'])
    expect(result).to eq([
      'DELETE fruits',
      'Cannot delete fruits - it does not exist',
    ])
  end

  it 'move command for a nested directory' do
    result = run([
      'CREATE grains',
      'CREATE grains/squash',
      'CREATE vegetables',
      'LIST',
      'MOVE grains/squash vegetables',
      'LIST',
    ])
    expect(result).to eq([
      'CREATE grains',
      'CREATE grains/squash',
      'CREATE vegetables',
      'LIST',
      'grains',
      '  squash',
      'vegetables',
      'MOVE grains/squash vegetables',
      'LIST',
      'grains',
      'vegetables',
      '  squash',
    ])
  end

  it 'list command when no directories exist' do
    result = run(['LIST'])
    expect(result).to eq([
      'LIST',
    ])
  end

  it 'list command when one directory exists' do
    result = run(['CREATE fruits', 'LIST'])
    expect(result).to eq([
      'CREATE fruits',
      'LIST',
      'fruits',
    ])
  end

  it 'list command when one directory exists (multiple commands in a single string)' do
    result = run(["CREATE fruits\nLIST"])
    expect(result).to eq([
      'CREATE fruits',
      'LIST',
      'fruits',
    ])
  end

  it 'list command when two directories exists' do
    result = run(['CREATE fruits', 'CREATE vegetables', 'LIST'])
    expect(result).to eq([
      'CREATE fruits',
      'CREATE vegetables',
      'LIST',
      'fruits',
      'vegetables',
    ])
  end

  it 'list command when nested directories exists' do
    result = run([
      'CREATE fruits',
      'CREATE vegetables',
      'CREATE fruits/apples',
      'CREATE fruits/apples/fuji',
      'LIST',
    ])
    expect(result).to eq([
      'CREATE fruits',
      'CREATE vegetables',
      'CREATE fruits/apples',
      'CREATE fruits/apples/fuji',
      'LIST',
      'fruits',
      '  apples',
      '    fuji',
      'vegetables',
    ])
  end

  it 'full test commands match the expected output' do
    result = run([
      'CREATE fruits',
      'CREATE vegetables',
      'CREATE grains',
      'CREATE fruits/apples',
      'CREATE fruits/apples/fuji',
      'LIST',
      'CREATE grains/squash',
      'MOVE grains/squash vegetables',
      'CREATE foods',
      'MOVE grains foods',
      'MOVE fruits foods',
      'MOVE vegetables foods',
      'LIST',
      'DELETE fruits/apples',
      'DELETE foods/fruits/apples',
      'LIST',
    ])
    expect(result).to eq([
      'CREATE fruits',
      'CREATE vegetables',
      'CREATE grains',
      'CREATE fruits/apples',
      'CREATE fruits/apples/fuji',
      'LIST',
      'fruits',
      '  apples',
      '    fuji',
      'grains',
      'vegetables',
      'CREATE grains/squash',
      'MOVE grains/squash vegetables',
      'CREATE foods',
      'MOVE grains foods',
      'MOVE fruits foods',
      'MOVE vegetables foods',
      'LIST',
      'foods',
      '  fruits',
      '    apples',
      '      fuji',
      '  grains',
      '  vegetables',
      '    squash',
      'DELETE fruits/apples',
      'Cannot delete fruits/apples - fruits does not exist',
      'DELETE foods/fruits/apples',
      'LIST',
      'foods',
      '  fruits',
      '  grains',
      '  vegetables',
      '    squash',
    ])
  end
end
