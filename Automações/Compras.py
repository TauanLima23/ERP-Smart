import pyautogui
import time
import pyperclip
 
 
senhats = ""
 
# tempo de cada operação
pyautogui.PAUSE = .5
 
# abrir o windows e entrar no TS
 
pyautogui.hotkey("win","r",interval=0.0)
pyautogui.write(r"C:\Users\tauan\OneDrive\Documentos\Projetos", interval=0.0)
pyautogui.press("enter")
time.sleep(4)
 
#logar TS
pyautogui.write(senhats)
pyautogui.press("enter")
 
# logar Smart Estoq125
 
time.sleep(8)
pyautogui.hotkey("win","r",interval=0.1)
pyautogui.write(r"\Users\tauan.lima\Desktop\estoq125.exe", interval=0.0)
pyautogui.press("enter")
 
#login Smart
usuario = ""
senhasm = ""
 
time.sleep(3)
pyautogui.write(usuario)
pyautogui.press("tab")
pyautogui.write(senhasm)
pyautogui.press("enter")
 
time.sleep(1)
pyautogui.press("tab")
pyautogui.press("enter")
 
# Entrar na operação
 
pyautogui.click(x=21, y=25, clicks=1)
pyautogui.click(x=48, y=54, clicks=1)
pyautogui.click(x=258, y=168, clicks=1)
pyautogui.click(x=462, y=174, clicks=1)
time.sleep(2)
pyautogui.press("F4")
pyautogui.press('F3')
pyautogui.press('F5')
 
# Ler tabela
import pandas as pd
 
# Leitura do arquivo CSV
tabela = pd.read_csv('Smart_SC.csv', delimiter=';')
 
# Loop através das linhas do DataFrame
for linha in tabela.index:
    codigo = str(tabela.loc[linha, 'codigo'])
 
    if "quebra" in codigo.lower():
        # Realize as operações específicas para a palavra "quebra"
        pyautogui.press('F8')
        time.sleep(4)
        pyautogui.click(x=645, y=300, clicks=1)
        time.sleep(3)
        pyautogui.press('esc')
        pyautogui.press('esc')
        pyautogui.press('F4')
        pyautogui.press('F3')
        pyautogui.press('F5')
 
        # Continue para a próxima iteração do loop
        continue
    time.sleep(.6)  
    pyautogui.write(codigo)
    pyautogui.press('tab')
    pyautogui.press('tab')
    pyautogui.write(str(tabela.loc[linha, 'quantidade']))
 
    try:
        # Tente localizar a primeira imagem
        img = pyautogui.locateCenterOnScreen('motivo_primeiro.png')
       
        if img is not None:
            # Se a primeira imagem for encontrada, clique nela
            pyautogui.click(img.x, img.y)
        else:
            # Se a primeira imagem não for encontrada, tente localizar a segunda imagem
            img_alternativa = pyautogui.locateCenterOnScreen('motivo_segundo.png')
 
            if img_alternativa is not None:
                # Se a segunda imagem for encontrada, clique nela
                pyautogui.click(img_alternativa.x, img_alternativa.y)
            else:
                # Se nenhuma das imagens for encontrada, imprima uma mensagem ou faça algo diferente
                print("Nenhuma das imagens foi encontrada.")
    except pyautogui.ImageNotFoundException:
        # Lidar com a exceção, se necessário
        print("Imagem não encontrada.")
    time.sleep(1)
    # Copia o motivo para a célula do Smart
    pyperclip.copy(tabela.loc[linha, 'motivo'])
    with pyautogui.hold('ctrl'):
        pyautogui.press('v')
    pyautogui.press('F5')
 
# enviar
pyautogui.press('F8')
time.sleep(4)
pyautogui.click(x=645, y=300, clicks=1)
time.sleep(3)
pyautogui.press('esc')
pyautogui.press('esc')
pyautogui.press('F4')  