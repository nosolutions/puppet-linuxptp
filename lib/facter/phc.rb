#Look for networking interfaces that have ptp devices
module PhcFact
  def self.add_facts
    phc = {}
    Dir.glob("/sys/class/net/*/device/ptp/*") do |dir|
      m = /\/sys\/class\/net\/(\S+)\/device\/ptp\/(\S+)/.match(dir)
      phc[m[1]] = m[2]
    end
    Facter.add("phc") do
      setcode do
        phc
      end
    end
  end
end

PhcFact.add_facts
