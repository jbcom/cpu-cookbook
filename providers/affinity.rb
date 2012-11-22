#
# Cookbook Name:: cpu
# Provider:: cpu_affinity
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 20012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def findpid(pidOrFile)
  if ::File.file?(pidOrFile)
    if ::File.readable?(pidOrFile)
      pid = ::File.read(pidOrFile).to_i
    else
      Chef::Log.error("File #{pidOrFile} isn't readable")
    end
  else
    pid = pidOrFile.to_i
  end
  # Test if pid exist
  begin
    Process.getpgid( pid )
  rescue Errno::ESRCH
    Chef::Log.error("Pid #{pid} not found")
  end
  return pid
end

action :set do
  execute "set affinity" do
    command "taskset --cpu-list --pid #{new_resource.cpu} #{findpid(new_resource.pid)}"
  end
end