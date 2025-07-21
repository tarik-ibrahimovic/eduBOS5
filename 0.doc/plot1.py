import pandas as pd
import matplotlib.pyplot as plt

# Data
data = {
    'Processor': [
        'eduBOSS5 (RISC-V) @54 MHz', 
        'PicoRV32 (RISC-V) @54 MHz', 
        'ARM Cortex-M0 @50 MHz', 
        'AVR ATmega328P @16 MHz', 
        'Raspberry Pi Pico @133 MHz'
    ],
    'DMIPS': [24.15, 11.99, 45, 8, 361],
    'DMIPS/MHz': [0.447, 0.222, 0.9, 0.5, 2.72]
}

df = pd.DataFrame(data)

# Plot
fig, ax1 = plt.subplots(figsize=(14, 7))

bar_width = 0.4
x = range(len(df))

# DMIPS Bars
dmips_bars = ax1.bar([i - bar_width/2 for i in x], df['DMIPS'], 
                     width=bar_width, label='DMIPS', color='#4a90e2')

# DMIPS/MHz Bars (Secondary Axis)
ax2 = ax1.twinx()
dmips_mhz_bars = ax2.bar([i + bar_width/2 for i in x], df['DMIPS/MHz'], 
                         width=bar_width, label='DMIPS/MHz', color='#50e3c2')

# Labels and Titles
ax1.set_ylabel('DMIPS', fontsize=16)
ax2.set_ylabel('DMIPS/MHz', fontsize=16)
ax1.set_title('Dhrystone Performance Comparison of CPUs', fontsize=22, pad=20)
ax1.set_xticks(x)
ax1.set_xticklabels(df['Processor'], rotation=30, ha='right', fontsize=14)
ax1.tick_params(axis='y', labelsize=14)
ax2.tick_params(axis='y', labelsize=14)

# Add labels on top
for bar in dmips_bars:
    height = bar.get_height()
    ax1.annotate(f'{height:.1f}', xy=(bar.get_x() + bar.get_width() / 2, height),
                 xytext=(0, 5), textcoords='offset points',
                 ha='center', va='bottom', fontsize=12)

for bar in dmips_mhz_bars:
    height = bar.get_height()
    ax2.annotate(f'{height:.2f}', xy=(bar.get_x() + bar.get_width() / 2, height),
                 xytext=(0, 5), textcoords='offset points',
                 ha='center', va='bottom', fontsize=12)

# Legends
bars = [dmips_bars, dmips_mhz_bars]
labels = ['DMIPS', 'DMIPS/MHz']
ax1.legend(bars, labels, loc='upper left', fontsize=14)

plt.tight_layout()
plt.show()
