def strip_doc(doc)
  doc.gsub(/^#{doc[/\A +/]}/,'')
end
