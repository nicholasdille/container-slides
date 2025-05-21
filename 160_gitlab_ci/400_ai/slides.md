<!-- .slide: id="gitlab_ai" class="vertical-center" -->

<i class="fa-duotone fa-microchip-ai fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## AI / LLM / ML

---

## AI Considerations

Just thinking about code suggestions?

Do you want support for code reviews?

Use GitLab Duo or operate something on your own?

Make or buy?

---

## GitLab Duo (again <i class="fa-duotone fa-solid fa-face-woozy"></i>)

Licenses: Core, Pro and Ultimate

Core for code suggestions and chat **in the IDE**

Pro for code suggestions and chat **in the web UI**

Ultimate for summarization and code review

See earlier slide [](#/gitlab_duo)

### Self Hosted Option [](https://docs.gitlab.com/administration/gitlab_duo_self_hosted/)

Additional components: Model and AI Gateway

Self hosted model for control over data

Self hosted AI Gateway for control over performance and rate limits

---

## Links

### Assistents

Strong focus on code review/summarization

Random examples: github.com/rkbansal/gitlab-ai-reviewer [](https://github.com/rkbansal/gitlab-ai-reviewer) | github.com/somnus-stasis/gitlab-mr-ai [](https://github.com/somnus-stasis/gitlab-mr-ai) | github.com/preslaff/ai-code-reviewer [](https://github.com/preslaff/ai-code-reviewer)

### Code suggestions

Examples: Tabby ML [](https://www.tabbyml.com/), Tab Nine [](https://www.tabnine.com/)

### AI-first IDEs

Examples: Cursor [](https://www.cursor.com/), Windsurf [](https://windsurf.com/editor), Void [](https://voideditor.com/), Zed [](https://zed.dev/)

### Terminals

Examples: Warp [](https://warp.dev/)

---

## Model Context Protocol (MCP)

Build your own AI agents...
- with access to different systems
- read information
- send to LLMs for processing
- change systems

Standardized by MCP [](https://modelcontextprotocol.io)

List of MCP servers [](https://github.com/modelcontextprotocol/servers) and [](https://mcpmarket.com/search?q=gitlab)

Examples for GitLab (random order):

- gitlab-mcp-server [](https://github.com/LuisCusihuaman/gitlab-mcp-server)
- aio-mcp [](https://github.com/athapong/aio-mcp)
- mcp-gitlab-server [](https://github.com/yoda-digital/mcp-gitlab-server)
- gitlab-mcp [](https://github.com/zereight/gitlab-mcp)
