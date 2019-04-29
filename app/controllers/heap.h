#pragma once
#include "../data/data.h"

/** Estructura de un min heap */
typedef struct heap
{
  /** Numero de elementos */
  int count;
  /** Tamanio del array */
  int size;
  /** Arreglo de vectores */
  Vector** array;
} Heap;

/** Inicializa un heap vacio */
Heap* heap_init(int size);

/** Inserta un elemento en el heap *
void heap_insert(Heap* heap, Vector* vtr, int axis);

/** Elimina la cabeza del heap y la retorna */
Vector* heap_pop(Heap* heap, int axis);

/** Ordena un arreglo de objetos usando un heap */
void heapsort(Vector** array, int size, int axis, Vector** array_save);

/** Destruye el heap */
void heap_destroy(Heap* heap);
