x = int(input("Enter time in minutes: "))

hours = int(x / 60)
minutes = int(x % 60)
h_label = "hr" if hours == 1 else "hrs"
m_label = "minute" if minutes == 1 else "minutes"

print(f"{hours} {h_label} {minutes} {m_label}")