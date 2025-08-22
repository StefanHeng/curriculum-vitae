from os.path import join as os_join
from pdfminer.high_level import extract_text


path = "tex_output/main.pdf"
# path = "test-lang/tex_output/check-ul2.pdf"
t = extract_text(path)

with open(os_join("check-parse", "main-pdf-miner.txt"), "w", encoding="utf-8") as f:
    f.write(t)
