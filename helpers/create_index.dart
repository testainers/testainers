import 'dart:io';

import 'package:markdown/markdown.dart';

void main(List<String> args) {
  if (args.length != 2) {
    print('Uso: dart run helpers/create_index.dart <arquivo_markdown> <arquivo_saida_html>');
    exit(10);
  }

  final File mdFile = File(args.first);

  if (!mdFile.existsSync()) {
    print('Erro: Arquivo Markdown não encontrado.');
    exit(20);
  }

  const String template = '''
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>testainers</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
          
    <style>
        body { 
            background-color: #0d1117; 
            color: #c9d1d9; 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans", Helvetica, Arial, sans-serif;
        }
        a { color: #58a6ff; text-decoration: none; }
        a:hover { text-decoration: underline; }
        img { max-width: 100%; height: auto; }
        h1 img { max-height: 50px; margin-right: 10px; vertical-align: middle; }
        table { 
            width: 100%; 
            margin-bottom: 1.5rem; 
            border-collapse: collapse; 
            font-size: 0.95rem;
        }
        th, td { 
            padding: 0.75rem 1rem; 
            border: 1px solid #30363d; 
        }
        th { 
            background-color: #21262d; 
            font-weight: 600; 
            text-align: center;
        }
        tr:nth-child(even) { background-color: #161b22; }
        pre { 
            background-color: #161b22; 
            padding: 1rem; 
            border-radius: 6px; 
            border: 1px solid #30363d;
            overflow-x: auto; 
        }
        code { 
            color: #ff7b72; 
            background-color: rgba(110,118,129,0.1);
            padding: 0.2em 0.4em;
            border-radius: 6px;
            font-family: ui-monospace, SFMono-Regular, Consolas, "Liberation Mono", monospace; 
            font-size: 0.9em; 
        }
        pre code { 
            color: #e6edf3; 
            background-color: transparent;
            padding: 0;
        }
        blockquote { 
            border-left: 4px solid #30363d; 
            padding-left: 1rem; 
            color: #8b949e; 
            margin-left: 0;
        }
        hr { border-color: #30363d; margin: 2rem 0; }
        h1, h2, h3, h4, h5, h6 { 
            margin-top: 24px; 
            margin-bottom: 16px; 
            font-weight: 600; 
            line-height: 1.25; 
            color: #ffffff;
        }
        h1 { font-size: 2em; border-bottom: 1px solid #21262d; padding-bottom: 0.3em; }
        h2 { font-size: 1.5em; border-bottom: 1px solid #21262d; padding-bottom: 0.3em; }
    </style>
</head>
<body>
  <div class="container col-lg-8 mx-auto p-4 py-md-5">
    <main>
{{body}}
    </main>
  </div>
  
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
          integrity="sha384-YvpcrYf0tY3lHB60NNkmxc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
          crossorigin="anonymous"></script>
</body>
</html>
''';

  final String generatedHtml = template.replaceAll(
    '{{body}}',
    markdownToHtml(
      mdFile.readAsStringSync(),
      extensionSet: ExtensionSet.gitHubWeb,
    ),
  );

  File(args.last)
    ..createSync(recursive: true)
    ..writeAsStringSync(generatedHtml);

  print('Página HTML gerada com sucesso em: ${args.last}');
}