/'
 ' FROST x86 microkernel
 ' Copyright (C) 2010-2017  Stefan Schmidt
 '
 ' This program is free software: you can redistribute it and/or modify
 ' it under the terms of the GNU General Public License as published by
 ' the Free Software Foundation, either version 3 of the License, or
 ' (at your option) any later version.
 '
 ' This program is distributed in the hope that it will be useful,
 ' but WITHOUT ANY WARRANTY; without even the implied warranty of
 ' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ' GNU General Public License for more details.
 '
 ' You should have received a copy of the GNU General Public License
 ' along with this program.  If not, see <http://www.gnu.org/licenses/>.
 '/

#pragma once

#include "kernel.bi"

extern apic_enabled as boolean

declare sub set_interrupt_override (irq as uinteger, gsi as uinteger, active_high as boolean, edge_triggered as boolean)
declare sub lapic_init ()
declare sub lapic_eoi ()
declare sub ioapic_init ()
declare sub lapic_startup_ipi (trampoline_addr as any ptr)
declare sub ioapic_unmask_irq (irq as uinteger)
declare sub ioapic_mask_irq (irq as uinteger)
declare sub ioapic_register (base_p as uinteger, global_system_interrupt_base as uinteger)
