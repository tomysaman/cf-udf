<!--- Author: Adam Cameron | https://blog.adamcameron.me/2024/03/cfml-solving-cfml-problem-with-java.html --->
<cfscript>
// prettyPrintByTransformer(): Pretty-formatting XML
public string function prettyPrintByTransformer(required string xmlString, numeric indent=4, boolean ignoreDeclaration=true) {
	var xmlAsStringReader = createObject("java", "java.io.StringReader").init(xmlString)
	var src = createObject("java", "org.xml.sax.InputSource").init(xmlAsStringReader)

	var document = createObject("java", "javax.xml.parsers.DocumentBuilderFactory").newInstance().newDocumentBuilder().parse(src)

	var transformerFactory = createObject("java", "javax.xml.transform.TransformerFactory").newInstance()
	var transformer = transformerFactory.newTransformer()

	var outputKeys = createObject("java", "javax.xml.transform.OutputKeys")
	transformer.setOutputProperty(outputKeys.ENCODING, "UTF-8")
	transformer.setOutputProperty(outputKeys.OMIT_XML_DECLARATION, ignoreDeclaration ? "yes" : "no");
	transformer.setOutputProperty(outputKeys.INDENT, "yes")
	transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", indent)

	var out = createObject("java", "java.io.StringWriter").init()

	var documentAsDomSource = createObject("java", "javax.xml.transform.dom.DOMSource").init(document)
	var outAsStreamResult = createObject("java", "javax.xml.transform.stream.StreamResult").init(out)
	transformer.transform(documentAsDomSource, outAsStreamResult)

	return out.toString()
}
</cfscript>