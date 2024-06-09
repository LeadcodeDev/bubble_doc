# Bubble Documentation

## Motivation

There are a multitude of tools for designing documentation, such
as [Undocs](https://undocs.pages.dev), [VitePress](https://vitepress.dev), [Docusaurus](https://docusaurus.io)
and [Docs-boilerplate](https://github.com/dimerapp/docs-boilerplate) used for all Adonis packages.
The problem, with the exception of the Adonis boilerplate, is that they all use a frontend framework/library which, in
my opinion, is not necessary for the design of documentation.

When we talk about documentation and thus a "content first" approach, we think directly of
the [Astro framework](https://astro.build/) which promises relatively efficient generation of static documents from
markdown files; however, this tool is not designed to be used fully for project documentation.

This is why I decided to create Bubble, a tool for generating documentation from markdown files without the need to use
a frontend framework.

### Choice of technologies

As a big fan of the Dart language, I decided to create Bubble using the Dart language in order to take advantage of its
content generation speed during the build phase.

> [!NOTE]
> Bubble can generate more pages than Astro 👀

## Installation

Installing Bubble is very simple, just use this repository as
the [template](https://github.com/new?template_name=bubble_doc&template_owner=LeadcodeDev) for your project.

Once done, simply run the following command to install the dependencies:

```bash
dart pub get
```

## Benchmark

Bubble is a very fast tool for generating documentation, here is a comparison with other tools:

- Mac Studio M2
- Template documentation with one collection and one marddkwn page

| Iteration | Astro  | Bubble  |
|-----------|--------|---------|
| 10        | 490ms  | 21ms    |
| 100       | 720ms  | 276ms   |
| 1000      | 2690ms | 2462ms  |
| 10000     | ?      | 25338ms |
