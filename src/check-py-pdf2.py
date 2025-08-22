from os.path import join as os_join

from PyPDF2 import PdfReader

txt = "".join((p.extract_text() or "") for p in PdfReader("tex_output/main.pdf").pages)

with open(os_join("check-parse", "main-py-pdf2.txt"), "w", encoding="utf-8") as f:
    f.write(txt)
