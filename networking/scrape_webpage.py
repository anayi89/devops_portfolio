from bs4 import BeautifulSoup
import requests

def main():
    page  = requests.get('https://liveindex.org/technical-signals/')
    soup = BeautifulSoup(page.text, 'html.parser')

    # table = soup.find_all('tr')
    # print(table)

    links = soup.find_all('table')
    for link in links:
        names = link.contents[0]
        print(names)

if __name__ == "__main__":
    main()
