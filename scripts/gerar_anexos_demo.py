import os
import sys

from PIL import Image, ImageDraw, ImageFont

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DESTINO = os.path.join(RAIZ, "app", "uploads")


def gerar_pdf(caminho, texto):
    bruto = texto.encode("cp1252")
    bruto = bruto.replace(b"\\", b"\\\\").replace(b"(", b"\\(").replace(b")", b"\\)")
    conteudo = b"BT /F1 20 Tf 60 720 Td (" + bruto + b") Tj ET"
    objetos = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] "
        b"/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
        b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>",
        b"<< /Length " + str(len(conteudo)).encode() + b" >>\nstream\n" + conteudo + b"\nendstream",
    ]
    pdf = bytearray(b"%PDF-1.4\n")
    offsets = []
    for i, obj in enumerate(objetos, start=1):
        offsets.append(len(pdf))
        pdf += f"{i} 0 obj\n".encode() + obj + b"\nendobj\n"
    inicio_xref = len(pdf)
    pdf += f"xref\n0 {len(objetos) + 1}\n".encode()
    pdf += b"0000000000 65535 f \n"
    for off in offsets:
        pdf += f"{off:010d} 00000 n \n".encode()
    pdf += (f"trailer\n<< /Size {len(objetos) + 1} /Root 1 0 R >>\n"
            f"startxref\n{inicio_xref}\n%%EOF\n").encode()
    with open(caminho, "wb") as f:
        f.write(pdf)


def gerar_png(caminho, texto):
    img = Image.new("RGB", (600, 400), (240, 244, 248))
    d = ImageDraw.Draw(img)
    d.rectangle([10, 10, 589, 389], outline=(120, 140, 170), width=3)
    try:
        fonte = ImageFont.truetype("arial.ttf", 28)
    except OSError:
        fonte = ImageFont.load_default(size=28)
    caixa = d.textbbox((0, 0), texto, font=fonte)
    x = (600 - (caixa[2] - caixa[0])) / 2
    y = (400 - (caixa[3] - caixa[1])) / 2
    d.text((x, y), texto, fill=(30, 40, 60), font=fonte)
    img.save(caminho, "PNG", optimize=True)


def main():
    os.makedirs(DESTINO, exist_ok=True)
    open(os.path.join(DESTINO, ".gitkeep"), "a").close()
    pdf = os.path.join(DESTINO, "demo_plano_acao.pdf")
    png = os.path.join(DESTINO, "demo_registro_oficina.png")
    gerar_pdf(pdf, "Plano de ação (arquivo de demonstração)")
    gerar_png(png, "Registro da oficina (demonstração)")
    for c in (pdf, png):
        print(f"{c}: {os.path.getsize(c)} bytes")


if __name__ == "__main__":
    sys.exit(main())
