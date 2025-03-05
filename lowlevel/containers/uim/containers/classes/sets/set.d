module uim.containers.classes.sets.set;

import uim.containers;
@safe:

class DSet(T : UIMObject) {
    protected T[] _items;
    
    public {
        this() {
            head = null;
            size = 0;
        }
        void insert(T value) {
            DNode node = new DNode;
            node.value = value;
            if (head == null) {
                head = node;
            } else {
                DNode current = head;
                while (current.next != null) {
                    if (current.value == value) {
                        return;
                    }
                    current = current.next;
                }
                if (current.value == value) {
                    return;
                }
                current.next = node;
            }
            size++;
        }
        void remove(T value) {
            if (head == null) {
                return;
            }
            if (head.value == value) {
                head = head.next;
                size--;
                return;
            }
            DNode current = head;
            while (current.next != null) {
                if (current.next.value == value) {
                    current.next = current.next.next;
                    size--;
                    return;
                }
                current = current.next;
            }
        }
        bool contains(T value) {
            DNode current = head;
            while (current != null) {
                if (current.value == value) {
                    return true;
                }
                current = current.next;
            }
            return false;
        }
        T getSize() {
            return size;
        }
    }
}