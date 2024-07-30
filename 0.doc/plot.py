import pandas as pd
import matplotlib.pyplot as plt

# Data from the table
data = {
    'Processor': [
        'eduBOSS5 (RISC-V) @54 MHz', 
        'PicoRV32 (RISC-V) @54 MHz', 
        'ARM Cortex-M0 @50 MHz', 
        'ARM Cortex-M3 @100 MHz', 
        'AVR ATmega328P @16 MHz', 
        'Pentium (x86) @75 MHz', 
        'Raspberry Pi Pico @133 MHz'
    ],
    'DMIPS': [21.6, 6.08, 45, 125, 8, 112, 361],
    'DMIPS/MHz': [0.39, 0.112, 0.9, 1.25, 0.5, 1.49, 2.72]
}

# Create a DataFrame
df = pd.DataFrame(data)

# Plotting the resource usage with updated processor names and frequencies
fig, ax1 = plt.subplots(figsize=(12, 6))

# Bar chart for DMIPS
dmips_bars = df.plot(kind='bar', x='Processor', y='DMIPS', ax=ax1, color='skyblue', position=0, width=0.3, label='DMIPS')
ax1.set_ylabel('DMIPS / DMIPS/MHz')
ax1.set_title('Dhrystone Performance Comparison of CPUs')


# Secondary axis for DMIPS/MHz
ax2 = ax1.twinx()
dmips_mhz_bars = df.plot(kind='bar', x='Processor', y='DMIPS/MHz', ax=ax2, color='lightgreen', position=1, width=0.3, label='DMIPS/MHz')
ax2.set_ylabel('')

# Adding exact numbers on top of bars for DMIPS
for container in ax1.containers:
    labels = [f'{v.get_height():.1f}' for v in container]
    ax1.bar_label(container, labels=labels, label_type='edge', fontsize=8)

# Adding exact numbers on top of bars for DMIPS/MHz
for container in ax2.containers:
    labels = [f'{v.get_height():.2f}' for v in container]
    ax2.bar_label(container, labels=labels, label_type='edge', fontsize=8)

# Adjusting the plot to ensure readability
plt.xticks(rotation=45, ha='right')
ax1.set_xticklabels(df['Processor'], rotation=45, ha='right')
plt.subplots_adjust(bottom=0.25)
plt.tight_layout()

# Adding the legend
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()

ax1.legend(lines1, labels1, loc='upper left', bbox_to_anchor=(0, 0.85))
ax2.legend(lines2, labels2, loc='upper left', bbox_to_anchor=(0, 0.95))

plt.tight_layout()
plt.show()
