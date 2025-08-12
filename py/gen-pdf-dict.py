data = ""

with open("dict.txt", 'r', encoding='utf-8') as f:
    lines = f.read().split("\n")
    for i in lines:
        info = i.split("-")
        if info != [""]:
            data += f"""BookmarkBegin\nBookmarkTitle: {info[0]}\nBookmarkLevel: 1\nBookmarkPageNumber: {info[1]}\n\n"""

with open("data.txt", "w", encoding="utf-8") as f:
    f.write(data)
