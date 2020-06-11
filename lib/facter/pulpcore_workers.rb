Facter.add(:pulpcore_workers) do
  setcode do
    directory = '/etc/systemd/system/multi-user.target.wants'
    worker_glob = 'pulpcore-worker@*.service'
    worker_template = '/etc/systemd/system/pulpcore-worker@.service'
    if File.exist?(worker_template)
      Dir[File.join(directory, worker_glob)].map do |worker|
        File.basename(worker)
      end
    else
      nil
    end
  end
end
