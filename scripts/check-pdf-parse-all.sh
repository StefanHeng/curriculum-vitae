tika -t tex_output/main.pdf > check-parse/main-tika.txt

pdftotext -enc UTF-8 -raw tex_output/main.pdf check-parse/main-pdftotext.txt

python src/check-pdf-miner.py

mutool draw -F txt -o - tex_output/main.pdf > check-parse/main-mupdf.txt

python src/check-py-pdf2.py

