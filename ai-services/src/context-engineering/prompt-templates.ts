export interface PromptTemplate {
  name: string;
  description: string;
  template: string;
  variables: string[];
}

export class PromptTemplateEngine {
  private templates: Map<string, PromptTemplate> = new Map();

  registerTemplate(template: PromptTemplate): void {
    this.templates.set(template.name, template);
  }

  render(templateName: string, variables: Record<string, string>): string {
    const template = this.templates.get(templateName);
    if (!template) {
      throw new Error(`Template not found: ${templateName}`);
    }

    let rendered = template.template;
    for (const [key, value] of Object.entries(variables)) {
      const regex = new RegExp(`\\{\\{${key}\\}\\}`, 'g');
      rendered = rendered.replace(regex, value);
    }

    return rendered;
  }

  listTemplates(): PromptTemplate[] {
    return Array.from(this.templates.values());
  }
}

// Default templates
export const defaultTemplates: PromptTemplate[] = [
  {
    name: 'code-review',
    description: 'Review code and provide feedback',
    template: `Review the following code and provide detailed feedback on:
- Code quality and best practices
- Potential bugs or issues
- Performance considerations
- Security vulnerabilities

Code:
{{code}}

Language: {{language}}`,
    variables: ['code', 'language']
  },
  {
    name: 'documentation',
    description: 'Generate documentation for code',
    template: `Generate comprehensive documentation for the following code:

{{code}}

Include:
- Overview of what the code does
- Parameter descriptions
- Return value description
- Usage examples
- Any important notes or warnings`,
    variables: ['code']
  },
  {
    name: 'bug-fix',
    description: 'Help debug and fix code issues',
    template: `I'm experiencing the following issue:

{{issue_description}}

Code:
{{code}}

Error message:
{{error_message}}

Please help me identify the root cause and suggest a fix.`,
    variables: ['issue_description', 'code', 'error_message']
  },
  {
    name: 'feature-implementation',
    description: 'Help implement a new feature',
    template: `Help me implement the following feature:

Feature Description:
{{feature_description}}

Existing Code Context:
{{context}}

Requirements:
{{requirements}}

Please provide a complete implementation with explanations.`,
    variables: ['feature_description', 'context', 'requirements']
  }
];
