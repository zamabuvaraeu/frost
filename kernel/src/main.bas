'' FROST 2 alpha version
'' Copyright (c) 2011 by darkinsanity

#include once "multiboot.bi"
#include once "gdt.bi"
#include once "idt.bi"
#include once "pic.bi"
#include once "pit.bi"
#include once "pmm.bi"
#include once "tasks.bi"
#include once "vmm.bi"
#include once "debug.bi"
#include once "panic.bi"
#include once "video.bi"
#include once "zstring.bi"

'' this sub really is the main function of the kernel.
'' it is called by start.asm after setting up the stack.
sub main (magicnumber as multiboot_uint32_t, mbinfo as multiboot_info ptr)
    video.clean()
    video.remove_cursor()
    
    if (mbinfo->flags and MULTIBOOT_INFO_CMDLINE) then                  '' we just check for the cmdline here
        dim k_cmd as zstring ptr = cast(zstring ptr, mbinfo->cmdline)
        
        if (z_instr(*k_cmd, "-verbose") > 0) then                       '' and now we parse it
            debug.set_loglevel(0)
        else
            debug.set_loglevel(2)
        end if
        
        if (z_instr(*k_cmd, "-no-clear-on-panic") > 0) then
            panic.set_clear_on_panic(0)
        end if
    end if
    
    video.set_color(9,0)
    debug_wlog(debug.INFO, "FROST V2 alpha\n")
    video.set_color(7,0)
    debug_wlog(debug.INFO, "name of the bootloader: %z\n", cast(zstring ptr, mbinfo->boot_loader_name))
    debug_wlog(debug.INFO, "cmdline: %z\n", cast(zstring ptr, mbinfo->cmdline))
    
    gdt.init()
    debug_wlog(debug.INFO, "gdt loaded\n")
    
    pic.init()
    debug_wlog(debug.INFO, "pic initialized\n")
    
    idt.init()
    debug_wlog(debug.INFO, "idt loaded\n")
    
    pit.set_frequency(100)
    debug_wlog(debug.INFO, "pit initialized\n")
    
    pmm.init(mbinfo)

    debug_wlog(debug.INFO, "physical memory manager initialized\n")
    debug_wlog(debug.INFO, "total RAM: %IMB\n", cuint(pmm.get_total()/1048576))
    debug_wlog(debug.INFO, "free RAM: %IMB\n", cuint(pmm.get_free()/1048576))
    
    debug_wlog(debug.INFO, "loading modules... ")
    'tasks.create_tasks_from_mb(mbinfo)
    debug_wlog(debug.INFO, "done.\n")
    
    debug_wlog(debug.INFO, "Initializing paging... \n")
    vmm.init()
    debug_wlog(debug.INFO, "\n")
    debug_wlog(debug.INFO, "it worked. babamm.\n")
    'asm mov eax, 42
    'asm int &h62
    asm hlt
    'debug_wlog(debug.INFO, !"done.\n")
    'asm sti
    'do : loop
end sub