module uim.containers.classes.lists.list;

class DList(T : UIMObject) {
    private {
        class DNode {
            public {
                DNode next;
                DNode prev;
                T value;
            }
        }
        DNode head;
        DNode tail;
        T size;
    }
    public {
        this() {
            head = null;
            tail = null;
            size = 0;
        }
        void pushFront(T value) {
            DNode node = new DNode;
            node.value = value;
            if (head == null) {
                head = node;
                tail = node;
            } else {
                node.next = head;
                head.prev = node;
                head = node;
            }
            size++;
        }
        void pushBack(T value) {
            DNode node = new DNode;
            node.value = value;
            if (tail == null) {
                head = node;
                tail = node;
            } else {
                node.prev = tail;
                tail.next = node;
                tail = node;
            }
            size++;
        }
        T popFront() {
            if (head == null) {
                return -1;
            }
            T value = head.value;
            head = head.next;
            if (head != null) {
                head.prev = null;
            } else {
                tail = null;
            }
            size--;
            return value;
        }
        T popBack() {
            if (tail == null) {
                return -1;
            }
            T value = tail.value;
            tail = tail.prev;
            if (tail != null) {
                tail.next = null;
            } else {
                head = null;
            }
            size--;
            return value;
        }
        T getSize() {
            return size;
        }
    }
}