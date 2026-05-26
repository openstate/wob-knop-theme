# See also spec/meta/duplicated_code_spec.rb
namespace :file_digests do
  task :compute, [:path] do |t, args|
    contents = File.read(args[:path])
    digest = Digest::MD5.hexdigest(contents)
    print("Digest of file: #{digest}\n")
  end
end
