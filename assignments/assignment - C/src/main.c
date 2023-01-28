#include "cycleDetection.h"

#include <stdio.h>
#include <stdlib.h>

LinkedList *LinkedList_new() {
	LinkedList *ll = malloc(sizeof(LinkedList));
	if(!ll) return NULL;
    ll->size = 0;
    ll->head = NULL;
    ll->tail = NULL;
	return ll;
}

void LinkedList_delete(LinkedList *ll) {
	LinkedListNode *ln = ll->head;
	while(ln != NULL) {
		LinkedListNode *next = ln->next;
		free(ln);
		ln = next;
	}
	free(ll);
}

LinkedListNode *LinkedList_append(LinkedList *ll, void *elem) {
	LinkedListNode *ln = malloc(sizeof(LinkedListNode));

	if(!ln) return NULL;
	if(ll->size > 0)
	{
		ll->tail->next = ln;
	}
	if(ll->size == 0)
	{
		ll->head = ln;
		ll->tail = ln;
		ln->prev = NULL;
	}
	else 
	{
		ln->prev = ll->tail;
	}
	ll->size++;
	ll->tail = ln;
	ln->data = elem;
	ln->next = NULL;
	return ln;
}

void *LinkedList_popFront(LinkedList *ll) {
	ll->size--;
	LinkedListNode *front = ll->head;
	if(front && front->next) {
		ll->head = front->next;
	}
	else {
		ll->head = NULL;
	}
	void *data = front->data;
	free(front);
	return data;
}

LinkedListNode *LinkedList_find(LinkedList *ll, void *elem) {
	LinkedListNode *ln = ll->head;
	while(ln != NULL && ln->data != elem) {
		ln = ln->next;
	}
	return ln;
}

void *LinkedList_remove(LinkedList *ll, LinkedListNode *node) {
	ll->size--;
	if(node->prev == NULL)
		ll->head = node->next;
	else
		node->prev->next = node->next;
	if(node->next == NULL)
		ll->tail = node->prev;
	else
		node->next->prev = node->prev;
	void *data = node->data;
	free(node);
	return data;
}

Graph *Graph_new(int n) {
	Graph *g = malloc(sizeof(Graph));
	if(!g) return NULL;
	g->numVertices = n;
	g->numEdges = 0;
	g->vertices = malloc(sizeof(Vertex)*n);
	if(!g->vertices) return NULL;
	for (int i = 0; i < n; i++)
	{
		g->vertices[i].id = i;
		g->vertices[i].inNeighbours = LinkedList_new();
		g->vertices[i].outNeighbours = LinkedList_new();
	}
	return g;
}

void Graph_addEdge(Graph *g, int i, int j) {
	g->numEdges++;
	LinkedList_append(g->vertices[i].outNeighbours, &g->vertices[j]);
	LinkedList_append(g->vertices[j].inNeighbours, &g->vertices[i]);
}

Graph *Graph_read(const char *filename) {
    FILE *file = fopen(filename, "r");
    char *line_buffer = NULL;
    size_t line_buffer_size = 0;
    getline(&line_buffer, &line_buffer_size, file);
	int numberOfVertices = atoi(line_buffer);
	Graph *g = Graph_new(numberOfVertices);
	for (int row = 0; row < numberOfVertices; row++) {
    	getline(&line_buffer, &line_buffer_size, file);
		for (int column = 0; column < numberOfVertices; column++) {
			if(line_buffer[column] == '1') {
				Graph_addEdge(g,row,column);
			}
		}
	}
	free(line_buffer);
    fclose(file);
	return g;
}

void Graph_delete(Graph *g) {
	for(int i = 0; i < g->numVertices; i++) {
		LinkedList_delete(g->vertices[i].inNeighbours);
		LinkedList_delete(g->vertices[i].outNeighbours);
	}
	free(g->vertices);
	free(g);
}

void Graph_print(Graph *g) {
	printf("edges %i vertice %i\n",g->numEdges, g->numVertices);
	for (int i = 0; i < g->numVertices; i++)
	{
		printf("id: %i in: %i out: %i\n", g->vertices[i].id, g->vertices[i].inNeighbours->size, g->vertices[i].outNeighbours->size);
	}
}

void cycleDetection(Graph *g) {
    LinkedList *L = LinkedList_new();
    LinkedList *S = LinkedList_new();
    for (int i = 0; i < g->numVertices; i++) {
        if(g->vertices[i].inNeighbours->size == 0) {
            LinkedList_append(S, &g->vertices[i]);
        }
    }
    while (S->size > 0)
    {
        Vertex *u = LinkedList_popFront(S);
        LinkedList_append(L,u);
        while(u->outNeighbours->size > 0) {
            Vertex *v = LinkedList_popFront(u->outNeighbours);
            if(v->inNeighbours->size == 1)
            {
                LinkedList_append(S,v);
            }
            LinkedList_remove(v->inNeighbours, LinkedList_find(v->inNeighbours,u));
        }
        
    }
    bool anyLeft = false;
    for(int i = 0; i < g->numVertices && !anyLeft; i++)
    {
        anyLeft = g->vertices[i].inNeighbours->size > 0 || g->vertices[i].outNeighbours->size > 0;
    }
    if(anyLeft)
    {
        printf("CYCLE DETECTED!\n");
    }
    else
    {
        while(L->size > 0) 
        {
            Vertex *v = LinkedList_popFront(L);
            printf("%i", v->id);
            if(L->size > 0){
                printf(", ");
            }
        }
        printf("\n");
    }
    LinkedList_delete(L);
    LinkedList_delete(S);
}

int main(int argc, char **argv) {
	if(argc < 2) {
		printf("Missing argument: input file\n");
		printf("Usage:\n");
		printf("%s <filename>\n", argv[0]);
		return 1;
	}
	
	Graph *g = Graph_read(argv[1]);
	if(!g) return 2;
	cycleDetection(g);
	Graph_delete(g);
	return 0;
}
