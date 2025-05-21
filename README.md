# RustMap

<div align="center">

![RustMap Banner](https://raw.githubusercontent.com/Wael-Rd/RustMap/main/banner.png)

A lightning-fast port scanning and enumeration tool that combines RustScan's blazing speed (up to 8000 ports/second) with Nmap's comprehensive scanning capabilities. RustMap significantly reduces scanning time from hours to minutes while maintaining thorough security assessment capabilities.

</div>

## Features

- 🚀 **Ultra-Fast Port Discovery**: Utilizes RustScan's async scanning (8000 ports/sec) for lightning-quick port detection
- 🔍 **Enhanced Nmap Integration**: Performs detailed service detection and enumeration
- 📊 **Modular Scanning**: Optional vulnerability, exploit, and safe script scanning
- 🎨 **Beautiful Output**: Colored terminal output with progress indicators
- 📝 **Detailed Reporting**: Comprehensive scan results saved to files
- 🔄 **Progress Tracking**: Real-time scanning progress with spinner animation

## Prerequisites

- RustScan
- Nmap
- Bash environment

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Wael-Rd/RustMap.git
```

2. Make the script executable:
```bash
chmod +x RustMap.sh
```

## Usage

Basic syntax:
```bash
./RustMap.sh [-v] [-e] [-s] <target> [target2 ...]
```

### Options

- `-v`: Enable vulnerability scripts
- `-e`: Enable exploit scripts
- `-s`: Enable safe scripts

### Examples

1. Basic scan:
```bash
./RustMap.sh 10.10.10.10
```

2. Scan with vulnerability and safe scripts:
```bash
./RustMap.sh -v -s 10.10.10.10
```

3. Full scan with all options:
```bash
./RustMap.sh -v -e -s 10.10.10.10
```

4. Scan multiple targets:
```bash
./RustMap.sh -v 10.10.10.10 10.10.10.11
```

## Output

The script generates a detailed report file for each target with the naming format: `rustmap_<target>.txt`

The report includes:
- RustScan results (fast port discovery)
- Service detection results
- Optional vulnerability scan results
- Optional exploit scan results
- Optional safe script results
- Full port enumeration details
- Key findings summary

## Performance

- ⚡ **Lightning-Fast Scanning**: Capable of scanning all 65,535 ports in under 10 seconds
- 🔄 **Efficient Resource Usage**: Optimized ulimit settings for maximum performance
- 🎯 **Smart Scanning**: Only runs detailed Nmap scans on open ports, saving significant time
- 💪 **Parallel Processing**: Utilizes async scanning for maximum throughput

## Features in Detail

1. **Initial Port Discovery**
   - Uses RustScan's async technology for ultra-fast initial port discovery (8000 ports/sec)
   - Configurable ulimit settings for optimal performance
   - Intelligent port selection to minimize false negatives

2. **Enhanced Nmap Scanning**
   - Service version detection with high intensity
   - Comprehensive port enumeration
   - Optional vulnerability assessment
   - Optional exploit checking
   - Optional safe script execution

3. **Output Processing**
   - Real-time progress tracking
   - Colored terminal output for better readability
   - Detailed logging of all scan results
   - Summary of key findings

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

- **mrx0rd**
- GitHub: [@Wael-Rd](https://github.com/Wael-Rd)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- RustScan team for their blazing-fast port scanner
- Nmap project for their powerful network scanning capabilities

## Disclaimer

This tool is for educational and ethical testing purposes only. Always ensure you have explicit permission to scan any target systems.
