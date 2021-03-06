module Squall
  # OnApp VirtualMachine
  class VirtualMachine < Base
    # Public: List all virtual machines.
    #
    # Returns an Array.
    def list
      response = request(:get, '/virtual_machines.json')
      response.collect { |v| v['virtual_machine'] }
    end

    # Public: Get info for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def show(id)
      response = request(:get, "/virtual_machines/#{id}.json")
      response.first[1]
    end

    # Public: Create a new virtual machine.
    #
    # options - Params for creating the virtual machine:
    #           admin_note                     - Comment that can only be set by
    #                                            admin of virtual machine
    #           allowed_hot_migrate            - Set to '1' to allow hot
    #                                            migration
    #           cpu_shares                     - CPU priority for this virtual
    #                                            machine
    #           cpus                           - Number of CPUs assigned to the
    #                                            virtual machine
    #           hostname                       - Hostname for the virtual machine
    #           hypervisor_group_id            - the ID of the hypervisor zone in
    #                                            which the VM will be created.
    #                                            Optional: if no hypervisor zone
    #                                            is set, the VM will be built in
    #                                            any available hypervisor zone.
    #           hypervisor_id                  - ID for a hypervisor where
    #                                            virtual machine will be built.
    #                                            If not provided the virtual
    #                                            machine will be assigned to the
    #                                            first available hypervisor
    #           initial_root_password          - Root password for the virtual
    #                                            machine. 6-31 characters
    #                                            consisting of letters, numbers,
    #                                            '-' and '_'
    #           label                          - Label for the virtual machine
    #           memory                         - Amount of RAM assigned to this
    #                                            virtual machine
    #           note                           - Comment that can be set by the
    #                                            user of the virtual machine
    #           primary_disk_size              - Disk space for this virtual
    #                                            machine
    #           primary_network_id             - ID of the primary network
    #           rate_limit                     - Max port speed
    #           required_automatic_backup      - Set to '1' if automatic backups
    #                                            are required
    #           required_ip_address_assignment - Set to '1' if you wish to
    #                                            assign an IP address
    #                                            automatically
    #           required_virtual_machine_build - Set to '1' to build virtual
    #                                            machine automatically
    #           swap_disk_size                 - Swap space (does not apply to
    #                                            Windows virtual machines)
    #           template_id                    - ID for a template from which
    #                                            the virtual machine will be
    #                                            built
    #
    # Example
    #     create(
    #       label:             'testmachine',
    #       hypervisor_id:     5,
    #       hostname:          'testmachine',
    #       memory:            512,
    #       cpus:              1,
    #       cpu_shares:        10,
    #       primary_disk_size: 10,
    #       template_id:       1
    #     )
    #
    # Returns a Hash.
    def create(options = {})
      response = request(:post, '/virtual_machines.json', default_params(options))
      response['virtual_machine']
    end

    # Public: Build a virtual machine.
    #
    # id      - ID of the virtual machine
    # options - Params for creating the virtual machine
    #           :required_startup - Set to '1' to startup virtual machine after
    #                               building
    #           :template_id      - ID of the template to be used to build the
    #                               virtual machine
    #
    # Returns a Hash.
    def build(id, options = {})
      response = request(:post, "/virtual_machines/#{id}/build.json", default_params(options))
      response.first[1]
    end

    # Public: Edit a virtual machine.
    #
    # id      - ID of the virtual machine
    # options - Params for creating the virtual machine, see `#create`
    #
    # Returns a Hash.
    def edit(id, options = {})
      response = request(:put, "/virtual_machines/#{id}.json", default_params(options))
      response['virtual_machine']
    end

    # Public: Change the owner of a virtual machine.
    #
    # id      - ID of the virtual machine
    # user_id - ID of the target User
    #
    # Returns a Hash.
    def change_owner(id, user_id)
      response = request(:post, "/virtual_machines/#{id}/change_owner.json", query: { user_id: user_id })
      response['virtual_machine']
    end

    # Public: Change the password.
    #
    # id       - ID of the virtual machine
    # password - New password
    #
    # Returns a Hash.
    def change_password(id, password)
      response = request(:post, "/virtual_machines/#{id}/reset_password.json", query: { new_password: password })
      response['virtual_machine']
    end

    # Public: Assigns SSH keys of all administrators and a owner to a virtual
    # machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def set_ssh_keys(id)
      response = request(:post, "/virtual_machines/#{id}/set_ssh_keys.json")
      response['virtual_machine']
    end

    # Public: Migrate a virtual machine to a new hypervisor.
    #
    # id      - ID of the virtual machine
    # options - A Hash of options:
    #           :destination              - ID of a hypervisor to which to
    #                                       migrate the virtual machine
    #           :cold_migrate_on_rollback - Set to '1' to switch to cold
    #                                       migration if migration fails
    #
    # Returns a Hash.
    def migrate(id, options = {})
      request(:post, "/virtual_machines/#{id}/migrate.json", query: { virtual_machine: options } )
    end

    # Public: Toggle the VIP status of the virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def set_vip(id)
      response = request(:post, "/virtual_machines/#{id}/set_vip.json")
      response['virtual_machine']
    end

    # Public: Delete a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/virtual_machines/#{id}.json")
    end

    # Public: Resize a virtual machine's memory.
    #
    # id      - ID of the virtual machine
    # options - Options for resizing:
    #           :memory            - Amount of RAM assigned to this virtual
    #                                machine
    #           :cpus              - Number of CPUs assigned to the virtual
    #                                machine
    #           :cpu_shares        - CPU priority for this virtual machine
    #           :allow_cold_resize - Set to '1' to allow cold resize
    #
    # Returns a Hash.
    def resize(id, options = {})
      response = request(:post, "/virtual_machines/#{id}/resize.json", default_params(options))
      response['virtual_machine']
    end

    # Public: Suspend/Unsuspend a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def suspend(id)
      response = request(:post, "/virtual_machines/#{id}/suspend.json")
      response['virtual_machine']
    end

    # Public: Unlock a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def unlock(id)
      response = request(:post, "/virtual_machines/#{id}/unlock.json")
      response['virtual_machine']
    end

    # Public: Boot a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def startup(id)
      response = request(:post, "/virtual_machines/#{id}/startup.json")
      response['virtual_machine']
    end

    # Public: Shutdown a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def shutdown(id)
      response = request(:post, "/virtual_machines/#{id}/shutdown.json")
      response['virtual_machine']
    end

    # Public: Stop a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def stop(id)
      response = request(:post, "/virtual_machines/#{id}/stop.json")
      response['virtual_machine']
    end

    # Public: Reboot a virtual machine
    #
    # id       - ID of the virtual machine
    # recovery - Set to true to reboot in recovery, defaults to false
    #
    # Returns a Hash.
    def reboot(id, recovery=false)
      response = request(:post, "/virtual_machines/#{id}/reboot.json", { query: recovery ? { mode: :recovery } : nil })
      response['virtual_machine']
    end

    # Public: Segregate a virtual machine from another virtual machine.
    #
    # id           - ID of the virtual machine
    # target_vm_id - ID of another virtual machine from which it should be
    #                segregated
    #
    # Returns a Hash.
    def segregate(id, target_vm_id)
      response = request(:post, "/virtual_machines/#{id}/strict_vm.json", default_params(strict_virtual_machine_id: target_vm_id))
      response['virtual_machine']
    end

    # Public: Open a console for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def console(id)
      response = request(:get, "/virtual_machines/#{id}/console.json")
      response['remote_access_session']
    end

    # Public: Get billing statistics for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns a Hash.
    def stats(id)
      response = request(:post, "/virtual_machines/#{id}/vm_stats.json")
      response['virtual_machine']
    end

    # Public: Get transactions for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns an Array of transaction objects.
    def transactions(id)
      response = request(:get, "/virtual_machines/#{id}/transactions.json")
      response
    end

    # Public: Get CPU stats for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns an Array of CPU usage objects.
    def cpu_usages(id)
      response = request(:get, "/virtual_machines/#{id}/cpu_usage.json")
      response
    end

    # Public: Get Network Interfaces for a virtual machine.
    #
    # id - ID of the virtual machine
    #
    # Returns an Array of Network Interface objects.
    def network_interfaces(id)
      response = request(:get, "/virtual_machines/#{id}/network_interfaces.json")
      response
    end

    # Public: Get Network stats for a virtual machine.
    #
    # id - ID of the virtual machine
    # network_id - Network Interface ID to check against
    #
    # Returns an Array of Network Hourly Stat objects.
    def network_usages(id, network_id)
      response = request(:get, "/virtual_machines/#{id}/network_interfaces/#{network_id}/usage.json")
      response
    end
  end
end
