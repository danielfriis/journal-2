---
title: Improving RAG Performance
date: 2024-08-26 12:03:00 +0100
---

By now, most people working with LLMs have either heard of or worked with RAG (Retrieval-Augmented Generation). However, finding good resources on how to make it work well in practice have been challenging to me. This is why I decided to write this note about my own learnings.

## Quick RAG introduction

RAG is a technique designed to reduce hallucinations and improve the accuracy of LLMs. Here's a brief overview of how it works:

1. **Retrieval**: When given a query, the system searches a database of relevant information.
2. **Augmentation**: The retrieved information is then added to the input prompt.
3. **Generation**: The AI model uses this augmented prompt to generate a more informed and accurate response.

![RAG Diagram](/assets/images/rag-article/basic-rag.svg)

This simple setup works well out of the box, but there are ways to significantly improve its performance.

## Improving the Retrieval Step

In my experience, the limiting factor for good RAG performance is the retrieval step. If you can find the right data, the rest of the system usually generates a good response.

To improve this step, it's important to understand how vector search works.

When you embed your data, you create a vector (i.e., numerical) representation of the text, which can be thought of as a point in a high-dimensional space. You do the same for your query. Searching means finding the closest points to your query in that space.

![Vector Search Diagram](/assets/images/rag-article/vector-search.svg)

Therefore, one of the most important tasks in improving the retrieval step is to bring your data points and queries closer in the vector space. Doing that means making them more similar to each other.

Very high-level, you can do this either by manipulating the data or the query. Both approaches are worth exploring, but the latter is usually most simple.

## Query Manipulation

There are several techniques you can use to manipulate the query to get it closer in the vector space to your data points.

- **Query Expansion**: Adding related terms to the query to cover more ground.
- **Hypothetical Document Embeddings**: Creating synthetic documents that represent potential queries.
- **Query Rewriting**: Rephrasing the query to better match the data points.
- **Multi-Query Retrieval**: Using multiple variations of the query to improve retrieval.
- **Query Decomposition**: Breaking down complex queries into simpler sub-queries.
- **Query Reformulation**: Iteratively refining the query based on initial retrieval results.
- **Contextual Query Expansion**: Expanding the query using context from the surrounding text.
- **Query-by-Example**: Using example documents to guide the retrieval process.

I've found the best results when using a combination of these techniques.

Specifically, I've seen the most success by breaking queries into its components (Query Decomposition), generating hypothetical chunks containing the answer (Hypothetical Document Embeddings), and running the generated queries in parallel (Multi-Query Retrieval). This returns a set of arrays of chunks, which I then rank by their distance to each query to generate a single ranked list of chunks.

It looks something like this:

![Multi-Query Retrieval Diagram](/assets/images/rag-article/query-manipulation.svg)

That's it! I've found that this approach significantly improves the retrieval step and leads to better overall RAG performance. If you have any other tips for improving RAG performance, feel free to reach out!