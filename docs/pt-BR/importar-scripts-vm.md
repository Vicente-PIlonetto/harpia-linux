# Importação segura dos scripts da VM

Objetivo: trazer os scripts existentes para revisão, sem executá-los nem expor dados locais.

1. Na VM, faça uma cópia de trabalho dos scripts; não edite o original durante a coleta.
2. Revise cada arquivo para IPs, nomes de host, caminhos pessoais, tokens, chaves, UUIDs, senhas e logs sensíveis.
3. Registre origem, data, hash SHA-256, finalidade, dependências, versão do livro LFS e fontes referenciadas.
4. Importe somente a cópia sanitizada para `scripts/imported/` em um PR dedicado.
5. Revise operações destrutivas, privilégios, downloads, verificações de assinatura e compatibilidade de versões antes de executar qualquer script.

Não execute exemplos desta página como procedimento de build. A auditoria deve comparar scripts, logs e fontes realmente usados antes de retomar LFS.
