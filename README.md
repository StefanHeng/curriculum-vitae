# curriculum-vitae

My curriculum vitae

Modified from AltaCV 1.7.3.
Major changes in coloring, styling and single-column layout.

Compiled with LuaLaTeX. ATS parsing fully supported. 

## ATS Compatibility 

Check by 

### 1. Poppler

```bash
pdftotext -enc UTF-8 -raw tex_output/main.pdf check-parse/main-pdftotext.txt

```

### 2. PyPDF2 & PDF Miner
```bash
conda create -n cv-ats-check python=3.11 pip

python3 -m pip install --upgrade PyPDF2
python3 -m pip install --upgrade "pdfminer.six==20240706"

python src/check-py-pdf2.py
python src/check-pdf-miner.py
```

### 3. Java/Tika/PDFBox 

```bash
brew install openjdk
echo 'export PATH="/usr/local/opt/openjdk/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

brew install tika

tika -t tex_output/main.pdf > check-parse/main-tika.txt
```


### MuPDF (mutool)

```bash
brew install mupdf

mutool draw -F txt -o - tex_output/main.pdf > check-parse/main-mupdf.txt
```


